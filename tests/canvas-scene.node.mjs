import assert from 'node:assert/strict';
import { test } from 'node:test';
import { drawCanvasSceneCommands } from '../canvas-scene-commands.mjs';
import { draw_scene_$x_ as drawCalcitScene } from '../js-out/js-ffi.canvas-scene.mjs';

function fakeContext() {
  const calls = [];
  return {
    canvas: { width: 80, height: 40 }, calls,
    save() { calls.push('save'); }, restore() { calls.push('restore'); },
    setTransform(...args) { calls.push(['setTransform', ...args]); },
    transform(...args) { calls.push(['transform', ...args]); },
    beginPath() { calls.push('beginPath'); },
    rect(...args) { calls.push(['rect', ...args]); },
    clip() { calls.push('clip'); },
    fillRect(...args) { calls.push(['fillRect', ...args]); },
  };
}

const orange = { r: 234 / 255, g: 88 / 255, b: 12 / 255, a: 1 };
const commands = [
  { kind: 'push', transform: [1, 0, 0, 1, 2, 3], clip: { kind: 'rect', x: 0, y: 0, width: 40, height: 40 }, opacity: 1 },
  { kind: 'rect', x: 10, y: 10, width: 4, height: 4, fill: orange },
  { kind: 'instances', positions: new Float32Array([1, 2, 5, 6]), count: 2, width: 2, height: 2, fill: orange },
  { kind: 'pop' },
];

test('Calcit Canvas scene API returns typed metrics after one ordered host batch', () => {
  const context = fakeContext();
  const result = drawCalcitScene(context, commands, 80, 40, 2);
  const metric = (key) => result.values[result.fields.findIndex(field => field.value === key)];
  assert.equal(metric('boundary-calls'), 1);
  assert.equal(metric('canvas-calls'), 4);
  assert.equal(metric('groups'), 1);
  assert.equal(metric('rectangles'), 1);
  assert.equal(metric('instances'), 2);
  assert.equal(metric('position-bytes-read'), 16);
  assert.deepEqual(context.canvas, { width: 160, height: 80 });
  assert.deepEqual(context.calls.filter(call => Array.isArray(call) && call[0] === 'fillRect').length, 4);
  assert.equal(context.calls.filter(call => call === 'save').length, context.calls.filter(call => call === 'restore').length);
});

test('scene validation is atomic and unsupported isolation is explicit', () => {
  const context = fakeContext();
  assert.throws(() => drawCanvasSceneCommands(context, [...commands, { kind: 'pop' }], 80, 40, 1), /unbalanced/);
  assert.throws(() => drawCanvasSceneCommands(context, [{ ...commands[0], opacity: 0.5 }, { kind: 'pop' }], 80, 40, 1), /isolated group opacity/);
  assert.throws(() => drawCanvasSceneCommands(context, [{ ...commands[2], positions: new Float32Array([1, NaN, 5, 6]) }], 80, 40, 1), /positions/);
  assert.deepEqual(context.calls, []);
  assert.deepEqual(context.canvas, { width: 80, height: 40 });
});
