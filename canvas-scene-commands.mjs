function finite(value, label) {
  if (!Number.isFinite(value)) throw new RangeError(`${label} must be finite`);
  return value;
}

function size(value, label) {
  if (finite(value, label) < 0) throw new RangeError(`${label} must be nonnegative`);
  return value;
}

function color(value) {
  if (!value || typeof value !== 'object') throw new TypeError('RGBA color required');
  for (const key of ['r', 'g', 'b', 'a']) {
    if (finite(value[key], `color.${key}`) < 0 || value[key] > 1) throw new RangeError(`color.${key} must be within 0..1`);
  }
  return `rgba(${Math.round(value.r * 255)}, ${Math.round(value.g * 255)}, ${Math.round(value.b * 255)}, ${value.a})`;
}

function validate(commands) {
  if (!Array.isArray(commands)) throw new TypeError('Canvas scene commands array required');
  let depth = 0;
  const prepared = [];
  for (const [index, command] of commands.entries()) {
    if (!command || typeof command !== 'object') throw new TypeError(`command ${index} must be an object`);
    switch (command.kind) {
      case 'push': {
        if (!Array.isArray(command.transform) || command.transform.length !== 6) throw new TypeError('affine transform requires six scalars');
        const transform = command.transform.map((value, offset) => finite(value, `transform.${offset}`));
        const clip = command.clip;
        if (clip?.kind !== 'none' && clip?.kind !== 'rect') throw new TypeError('unsupported Canvas clip');
        if (clip.kind === 'rect') {
          finite(clip.x, 'clip.x'); finite(clip.y, 'clip.y');
          size(clip.width, 'clip.width'); size(clip.height, 'clip.height');
        }
        if (command.opacity !== 1) throw new TypeError('isolated group opacity is not supported by this Canvas path');
        depth++;
        prepared.push({ kind: 'push', transform, clip });
        break;
      }
      case 'pop':
        if (depth === 0) throw new RangeError('unbalanced Canvas group pop');
        depth--;
        prepared.push({ kind: 'pop' });
        break;
      case 'rect':
        finite(command.x, 'rect.x'); finite(command.y, 'rect.y');
        size(command.width, 'rect.width'); size(command.height, 'rect.height');
        prepared.push({ kind: 'rect', ...command, style: color(command.fill) });
        break;
      case 'instances': {
        const positions = command.positions;
        if (!(positions instanceof Float32Array)) throw new TypeError('Float32Array instance positions required');
        if (typeof SharedArrayBuffer !== 'undefined' && positions.buffer instanceof SharedArrayBuffer) {
          throw new TypeError('SharedArrayBuffer instance positions are not stable');
        }
        if (!Number.isSafeInteger(command.count) || command.count < 0 || positions.length !== command.count * 2) {
          throw new RangeError('instance count must match interleaved positions');
        }
        size(command.width, 'instances.width'); size(command.height, 'instances.height');
        for (let i = 0; i < positions.length; i++) finite(positions[i], `positions.${i}`);
        prepared.push({ kind: 'instances', ...command, style: color(command.fill) });
        break;
      }
      default: throw new TypeError(`unsupported Canvas scene command ${String(command.kind)}`);
    }
  }
  if (depth !== 0) throw new RangeError('unclosed Canvas group');
  return prepared;
}

/** Execute a prevalidated flat Scene draw list in one host boundary crossing. */
export function drawCanvasSceneCommands(context, commands, width, height, dpr) {
  if (!context || typeof context.save !== 'function' || typeof context.restore !== 'function' ||
      typeof context.setTransform !== 'function' || typeof context.transform !== 'function' ||
      typeof context.fillRect !== 'function' || typeof context.beginPath !== 'function' ||
      typeof context.rect !== 'function' || typeof context.clip !== 'function' || !context.canvas) {
    throw new TypeError('CanvasRenderingContext2D required');
  }
  size(width, 'width'); size(height, 'height');
  if (finite(dpr, 'dpr') <= 0) throw new RangeError('dpr must be positive');
  const pixelWidth = Math.round(width * dpr);
  const pixelHeight = Math.round(height * dpr);
  if (!Number.isSafeInteger(pixelWidth) || !Number.isSafeInteger(pixelHeight)) throw new RangeError('canvas pixel size overflow');
  const prepared = validate(commands); // No canvas mutation before the entire draw list is valid.
  if (context.canvas.width !== pixelWidth) context.canvas.width = pixelWidth;
  if (context.canvas.height !== pixelHeight) context.canvas.height = pixelHeight;
  let groups = 0;
  let rectangles = 0;
  let instances = 0;
  let positionBytesRead = 0;
  let open = 0;
  context.save();
  try {
    context.setTransform(1, 0, 0, 1, 0, 0);
    context.fillStyle = '#ffffff';
    context.fillRect(0, 0, pixelWidth, pixelHeight);
    context.setTransform(dpr, 0, 0, dpr, 0, 0);
    for (const command of prepared) {
      if (command.kind === 'push') {
        context.save(); open++; groups++;
        context.transform(...command.transform);
        if (command.clip.kind === 'rect') {
          context.beginPath();
          context.rect(command.clip.x, command.clip.y, command.clip.width, command.clip.height);
          context.clip();
        }
      } else if (command.kind === 'pop') {
        context.restore(); open--;
      } else if (command.kind === 'rect') {
        context.fillStyle = command.style;
        context.fillRect(command.x, command.y, command.width, command.height);
        rectangles++;
      } else {
        context.fillStyle = command.style;
        const { positions } = command;
        for (let i = 0; i < command.count; i++) {
          context.fillRect(positions[i * 2], positions[i * 2 + 1], command.width, command.height);
        }
        instances += command.count;
        positionBytesRead += command.count * 8;
      }
    }
  } finally {
    while (open-- > 0) context.restore();
    context.restore();
  }
  return Object.freeze({ boundaryCalls: 1, canvasCalls: 1 + rectangles + instances, groups, rectangles, instances, positionBytesRead });
}
