// Cross-runtime host boundary. The caller only receives an opaque token;
// every exported typed array is a fresh copy, never the retained snapshot.
const float32Snapshots = new WeakMap();

function requireSnapshot(snapshot) {
  const values = snapshot !== null && typeof snapshot === 'object' && float32Snapshots.get(snapshot);
  if (values === undefined) throw new TypeError('Float32 snapshot required');
  return values;
}

function requireIndex(value, limit, label) {
  if (!Number.isSafeInteger(value) || value < 0 || value > limit) {
    throw new RangeError(`${label} must be a safe integer within 0..${limit}`);
  }
}

/** Copy a same-realm Float32Array into an immutable, opaque host snapshot. */
export function snapshotFloat32(source) {
  if (!(source instanceof Float32Array)) throw new TypeError('Float32Array source required');
  if (typeof SharedArrayBuffer !== 'undefined' && source.buffer instanceof SharedArrayBuffer) {
    throw new TypeError('SharedArrayBuffer source is not a stable snapshot');
  }
  const copy = new Float32Array(source);
  for (let index = 0; index < copy.length; index++) {
    if (!Number.isFinite(copy[index])) throw new RangeError(`Float32 source has non-finite value at ${index}`);
  }
  const snapshot = Object.freeze({});
  float32Snapshots.set(snapshot, copy);
  return snapshot;
}

export function float32Length(snapshot) {
  return requireSnapshot(snapshot).length;
}

export function float32ByteLength(snapshot) {
  return requireSnapshot(snapshot).byteLength;
}

export function float32At(snapshot, index) {
  const values = requireSnapshot(snapshot);
  requireIndex(index, values.length - 1, 'Float32 index');
  return values[index];
}

/** Return a mutable copy of a bounded range, suitable for upload or testing. */
export function float32CopyRange(snapshot, start, count) {
  const values = requireSnapshot(snapshot);
  requireIndex(start, values.length, 'Float32 range start');
  requireIndex(count, values.length - start, 'Float32 range count');
  return new Float32Array(values.subarray(start, start + count));
}
