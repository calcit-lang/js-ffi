import { query_string } from '../js-out/js-ffi.query-example.mjs';
import { listen } from '../js-out/js-ffi.listen-example.mjs';
import * as browser from '../js-out/js-ffi.browser.mjs';
import * as shared from '../js-out/js-ffi.shared.mjs';
import { option_$o_none_$q_ as isNone, option_$o_unwrap as unwrap, result_$o_err_$q_ as isErr, result_$o_ok_$q_ as isOk } from '../js-out/calcit.core.mjs';
import { assertions, testShared } from './shared.mjs';
import { testWebGpu, smokeWebGpu } from './webgpu.mjs';
import { drawFloat32RectBatch } from '../canvas-rect-batches.mjs';
import { draw_rects_$x_ as drawCalcitRectBatch, fill_solid_rect_$x_ as fillSolidRect } from '../js-out/js-ffi.canvas-batches.mjs';
import { draw_scene_$x_ as drawCalcitScene } from '../js-out/js-ffi.canvas-scene.mjs';
import { testWebGpuCapabilities } from './webgpu-capabilities.mjs';
import { testWebGpuRectBatches, smokeWebGpuRectBatches } from './webgpu-rect-batches.mjs';
import { testCalcitWebGpuBatches } from './webgpu-calcit-batches.mjs';
import { testCalcitWebGpuCapabilities } from './webgpu-calcit-capabilities.mjs';
import { probe_device_$x_ as probeCalcitWebGpuDevice } from '../js-out/js-ffi.webgpu-capabilities.mjs';
import { clear_canvas_$x_ as clearCanvas } from '../js-out/js-ffi.canvas-batches.mjs';
import { canvas_card as canvasCard } from '../js-out/js-ffi.canvas-example.mjs';
import { canvas_batch_card as canvasBatchCard } from '../js-out/js-ffi.canvas-batch-example.mjs';

/** Exercise shared and browser adapters in a real page and return the test summary. */
export async function run() {
  const a = assertions();
  await testWebGpu(a);
  await testWebGpuCapabilities(a);
  await testCalcitWebGpuCapabilities(a);
  await testWebGpuRectBatches(a);
  await testCalcitWebGpuBatches(a);
  const webgpu = await smokeWebGpu(a);
  const webgpuRect = await smokeWebGpuRectBatches(a);
  const capability = await probeCalcitWebGpuDevice(navigator);
  if (capability.tag.value === 'ready') {
    a.equal(['rgba8unorm', 'bgra8unorm'].includes(capability.extra[0].format), true);
    a.equal(capability.extra[0].release(), true);
  } else {
    a.equal(['unavailable', 'failed'].includes(capability.tag.value), true);
  }
  await testShared(a);
  const batchCanvas = document.createElement('canvas');
  batchCanvas.width = 80;
  batchCanvas.height = 40;
  const batchContext = batchCanvas.getContext('2d', { willReadFrequently: true });
  batchContext.fillStyle = '#ffffff';
  batchContext.fillRect(0, 0, 80, 40);
  const batchMetrics = drawFloat32RectBatch(batchContext, new Float32Array([10, 10, 30, 10]), 0, 2, 4, 4, '#ea580c', 1);
  a.equal(batchMetrics.boundaryCalls, 1);
  a.equal(batchMetrics.canvasCalls, 2);
  a.equal(Array.from(batchContext.getImageData(10, 10, 1, 1).data).join(','), '234,88,12,255');
  a.equal(Array.from(batchContext.getImageData(30, 10, 1, 1).data).join(','), '234,88,12,255');
  a.equal(Array.from(batchContext.getImageData(20, 10, 1, 1).data).join(','), '255,255,255,255');
  a.equal(batchContext.fillStyle, '#ffffff');
  const calcitMetrics = drawCalcitRectBatch(batchContext, new Float32Array([10, 10, 30, 10]), 0, 2, 4, 4, '#ea580c', 1);
  const metric = (key) => calcitMetrics.values[calcitMetrics.fields.findIndex(field => field.value === key)];
  a.equal(metric('boundary-calls'), 1);
  a.equal(metric('canvas-calls'), 2);
  a.equal(metric('instances'), 2);
  a.equal(metric('position-bytes-read'), 16);
  const primitiveCanvas = document.createElement('canvas');
  primitiveCanvas.width = 40;
  primitiveCanvas.height = 30;
  const primitiveContext = primitiveCanvas.getContext('2d', { willReadFrequently: true });
  primitiveContext.fillStyle = '#ffffff';
  primitiveContext.fillRect(0, 0, 40, 30);
  a.equal(fillSolidRect(primitiveContext, 6, 7, 12, 9, '#ea580c'), undefined);
  a.equal(Array.from(primitiveContext.getImageData(10, 10, 1, 1).data).join(','), '234,88,12,255');
  a.equal(Array.from(primitiveContext.getImageData(20, 10, 1, 1).data).join(','), '255,255,255,255');
  a.equal(primitiveContext.fillStyle, '#ffffff');
  const scopedCanvas = document.createElement('canvas');
  scopedCanvas.width = 40;
  scopedCanvas.height = 30;
  const scopedContext = scopedCanvas.getContext('2d', { willReadFrequently: true });
  scopedContext.fillStyle = '#ffffff';
  scopedContext.fillRect(0, 0, 40, 30);
  a.equal(canvasCard(scopedContext), undefined);
  const scopedPixel = (x, y) => Array.from(scopedContext.getImageData(x, y, 1, 1).data).join(',');
  a.equal(scopedPixel(10, 5), '234,88,12,255');
  a.equal(scopedPixel(6, 5), '255,255,255,255');
  a.equal(scopedPixel(18, 5), '255,255,255,255');
  a.equal(scopedPixel(10, 14), '255,255,255,255');
  a.equal(scopedContext.fillStyle, '#ffffff');
  a.equal(scopedContext.getTransform().e, 0);
  fillSolidRect(scopedContext, 25, 5, 3, 3, '#ea580c');
  a.equal(scopedPixel(26, 6), '234,88,12,255');
  a.equal(clearCanvas(scopedContext, 40, 30), undefined);
  a.equal(scopedPixel(10, 5), '0,0,0,0');
  a.equal(scopedPixel(26, 6), '0,0,0,0');
  a.equal(scopedContext.fillStyle, '#ffffff');
  const clippedBatchCanvas = document.createElement('canvas');
  clippedBatchCanvas.width = 30;
  clippedBatchCanvas.height = 20;
  const clippedBatchContext = clippedBatchCanvas.getContext('2d', { willReadFrequently: true });
  clippedBatchContext.fillStyle = '#ffffff';
  clippedBatchContext.fillRect(0, 0, 30, 20);
  const clippedBatchMetrics = canvasBatchCard(clippedBatchContext, new Float32Array([0, 4, 8, 4]));
  const clippedMetric = (key) => clippedBatchMetrics.values[clippedBatchMetrics.fields.findIndex(field => field.value === key)];
  a.equal(clippedMetric('instances'), 2);
  a.equal(clippedMetric('canvas-calls'), 2);
  a.equal(clippedMetric('position-bytes-read'), 16);
  const clippedPixel = (x, y) => Array.from(clippedBatchContext.getImageData(x, y, 1, 1).data).join(',');
  a.equal(clippedPixel(8, 5), '234,88,12,255');
  a.equal(clippedPixel(14, 5), '234,88,12,255');
  a.equal(clippedPixel(6, 5), '255,255,255,255');
  a.equal(clippedPixel(18, 5), '255,255,255,255');
  a.equal(clippedBatchContext.fillStyle, '#ffffff');
  a.equal(clippedBatchContext.getTransform().e, 0);
  a.throws(() => canvasBatchCard(clippedBatchContext, new Float32Array([0, 4, NaN, 4])), /non-finite batch coordinate/);
  a.equal(clippedBatchContext.getTransform().e, 0);
  a.equal(clippedBatchContext.fillStyle, '#ffffff');
  const sceneCanvas = document.createElement('canvas');
  const sceneContext = sceneCanvas.getContext('2d', { willReadFrequently: true });
  const scene = [
    { kind: 'push', transform: [1, 0, 0, 1, 5, 0], clip: { kind: 'rect', x: 0, y: 0, width: 20, height: 20 }, opacity: 1 },
    { kind: 'rect', x: 5, y: 5, width: 10, height: 10, fill: { r: 234 / 255, g: 88 / 255, b: 12 / 255, a: 1 } },
    { kind: 'pop' },
  ];
  const sceneMetrics = drawCalcitScene(sceneContext, scene, 40, 30, 2);
  const sceneMetric = (key) => sceneMetrics.values[sceneMetrics.fields.findIndex(field => field.value === key)];
  a.equal(sceneMetric('boundary-calls'), 1);
  a.equal(sceneMetric('groups'), 1);
  a.equal(sceneMetric('canvas-calls'), 2);
  a.equal(Array.from(sceneContext.getImageData(20, 20, 1, 1).data).join(','), '234,88,12,255');
  a.equal(Array.from(sceneContext.getImageData(60, 20, 1, 1).data).join(','), '255,255,255,255');
  const fetched = await shared.fetch_response(new URL('/tests/fixtures/async-body.txt', location.href).href);
  a.equal(isOk(fetched), true);
  const body = await shared.response_text(fetched.extra[0]);
  a.equal(isOk(body), true);
  a.equal(body.extra[0], 'browser async body\n');
  a.equal(isErr(await shared.response_text(fetched.extra[0])), true);
  a.equal(isErr(await shared.response_text({ text() { throw new Error('sync body failure'); } })), true);
  a.equal(isErr(await shared.response_text({ text() { return Promise.reject(new Error('async body failure')); } })), true);
  a.equal(query_string('中文 +&'), 'page=1&q=%E4%B8%AD%E6%96%87+%2B%26');
  let recipeEvents = 0;
  const cleanup = listen('js-ffi-recipe', () => { recipeEvents++; });
  try { window.dispatchEvent(new Event('js-ffi-recipe')); }
  finally { a.equal(cleanup(), undefined); }
  window.dispatchEvent(new Event('js-ffi-recipe'));
  a.equal(recipeEvents, 1);
  a.equal(cleanup(), undefined);
  a.equal(browser.document_available_$q_(), true);
  const parent = browser.create_element('section');
  const input = browser.create_element('input');
  a.equal(browser.element_host(parent), parent);
  a.throws(() => browser.element_host(null), /DOM\.element-host expected Object, got nullish/);
  a.equal(browser.document_append_body_$x_(parent), undefined);
  try {
    a.equal(browser.append_child_$x_(parent, input), input);
    a.equal(unwrap(browser.element_first_child(parent)), input);
    a.equal(isNone(browser.element_first_child(input)), true);
    a.equal(browser.element_set_attribute_$x_(input, 'data-test', '你好'), undefined);
    a.equal(unwrap(browser.element_get_attribute(input, 'data-test')), '你好');
    a.equal(isNone(browser.element_get_attribute(input, 'missing')), true);
    a.equal(browser.element_matches_$q_(input, 'input[data-test]'), true);
    a.equal(unwrap(browser.element_query_selector(parent, 'input')), input);
    a.equal(isNone(browser.element_query_selector(parent, '.missing')), true);
    a.throws(() => browser.element_query_selector(parent, '['), /SyntaxError/);
    a.equal(browser.element_remove_attribute_$x_(input, 'data-test'), undefined);
    a.equal(isNone(browser.element_get_attribute(input, 'data-test')), true);
    a.equal(browser.element_focus_$x_(input), undefined);
    a.equal(document.activeElement, input);
    input.value = 'select me';
    a.equal(browser.selectable_element_host(input), input);
    a.throws(() => browser.selectable_element_host(null), /DOM\.selectable-element-host expected Object, got nullish/);
    a.equal(browser.element_select_$x_(browser.selectable_element_host(input)), undefined);
    a.equal(input.selectionStart, 0);
    a.equal(input.selectionEnd, input.value.length);
    a.equal(browser.element_blur_$x_(input), undefined);
    a.equal(document.activeElement === input, false);
    a.equal(unwrap(browser.child_element_at(parent.children, 0)), input);
    a.equal(isNone(browser.child_element_at(parent.children, 1)), true);
    a.equal(browser.element_dataset(input), input.dataset);
    a.equal(browser.element_style(input), input.style);
    a.equal(browser.element_set_style_$x_(input, 'opacity', '0.5'), undefined);
    a.equal(input.style.opacity, '0.5');

    let parentEvents = 0;
    let inputEvents = 0;
    parent.addEventListener('js-ffi-dom', () => { parentEvents++; });
    input.addEventListener('js-ffi-dom', event => {
      inputEvents++;
      a.equal(browser.event_host(event), event);
      a.equal(browser.event_stop_propagation_$x_(event), undefined);
    });
    a.equal(browser.element_dispatch_event_$x_(input, new Event('js-ffi-dom', { bubbles: true })), true);
    a.equal(inputEvents, 1);
    a.equal(parentEvents, 0);

    const keyboardEvent = new KeyboardEvent('keydown', { key: 'Escape' });
    a.equal(browser.keyboard_event_host(keyboardEvent), keyboardEvent);
    a.equal(browser.keyboard_event_key(keyboardEvent), 'Escape');
    const mouseEvent = browser.mouse_event_from_event(browser.event_host(keyboardEvent));
    a.equal(mouseEvent instanceof MouseEvent, true);
    a.equal(mouseEvent.type, 'keydown');

    const cloned = browser.element_clone(parent, true);
    a.equal(cloned.children.length, 1);
    a.equal(browser.document_append_body_$x_(cloned), undefined);
    a.equal(browser.element_remove_$x_(cloned), undefined);
    a.equal(cloned.isConnected, false);
  } finally {
    browser.element_remove_$x_(parent);
  }
  const key = `js-ffi-test-${crypto.randomUUID()}`;
  try {
    a.equal(isNone(browser.storage_get(key)), true);
    a.equal(browser.storage_set_$x_(key, '中文'), undefined);
    a.equal(unwrap(browser.storage_get(key)), '中文');
    a.equal(browser.storage_remove_$x_(key), undefined);
    a.equal(browser.storage_get_or(key, 'fallback'), 'fallback');
  } finally { localStorage.removeItem(key); }

  let events = 0;
  const listener = () => { events++; };
  browser.add_event_listener_$x_('js-ffi-test', listener);
  try { window.dispatchEvent(new Event('js-ffi-test')); }
  finally { browser.remove_event_listener_$x_('js-ffi-test', listener); }
  window.dispatchEvent(new Event('js-ffi-test'));
  a.equal(events, 1);

  let fired = 0;
  const timeout = browser.set_timeout_$x_(() => { fired++; }, 0);
  const interval = browser.set_interval_$x_(() => { fired++; }, 1);
  const frame = browser.request_animation_frame_$x_(() => { fired++; });
  a.equal(typeof timeout, 'number');
  a.equal(typeof interval, 'number');
  a.equal(typeof frame, 'number');
  a.equal(browser.clear_timeout_$x_(timeout), undefined);
  a.equal(browser.clear_interval_$x_(interval), undefined);
  a.equal(browser.cancel_animation_frame_$x_(frame), undefined);
  await new Promise(resolve => setTimeout(resolve, 50));
  a.equal(fired, 0);
  await new Promise(resolve => browser.set_timeout_$x_(() => { resolve(); }, 0));
  await new Promise(resolve => browser.request_animation_frame_$x_(timestamp => {
    a.equal(typeof timestamp, 'number');
    resolve();
  }));

  a.equal(browser.document_host(), document);
  a.equal(unwrap(browser.document_element()), document.documentElement);
  a.equal(unwrap(browser.document_body()), document.body);
  a.equal(browser.location_host(), location);
  const locationField = (snapshot, name) => snapshot.values[snapshot.fields.findIndex(field => field.value === name)];
  const locationSnapshot = browser.location_snapshot();
  a.equal(locationField(locationSnapshot, 'href'), location.href);
  a.equal(locationField(locationSnapshot, 'origin'), location.origin);
  a.equal(locationField(locationSnapshot, 'hostname'), location.hostname);
  a.equal(locationField(locationSnapshot, 'pathname'), location.pathname);
  a.equal(locationField(locationSnapshot, 'protocol'), location.protocol);
  a.equal(locationField(locationSnapshot, 'port'), location.port);
  a.equal(locationField(locationSnapshot, 'search'), location.search);
  a.equal(locationField(locationSnapshot, 'hash'), location.hash);
  a.equal(browser.window_host(), window);
  a.equal(browser.user_agent(), navigator.userAgent);
  a.equal(browser.screen_width(), window.screen.width);
  a.equal(browser.screen_height(), window.screen.height);
  a.equal(shared.console_info_$x_('js-ffi browser smoke'), undefined);

  const svg = browser.create_element_ns('http://www.w3.org/2000/svg', 'svg');
  a.equal(svg.namespaceURI, 'http://www.w3.org/2000/svg');
  a.equal(svg.localName, 'svg');
  const form = browser.form_data_create();
  a.equal(browser.form_data_append_$x_(form, 'field', '值'), undefined);
  a.equal(form.has('field'), true);
  a.equal(form.get('field'), '值');
  form.delete('field');
  a.equal(form.has('field'), false);
  const opened = browser.window_open('about:blank');
  a.equal(opened !== undefined, true);
  if (!isNone(opened)) unwrap(opened).close();

  const focusTarget = browser.create_element('input');
  browser.document_append_body_$x_(focusTarget);
  try {
    focusTarget.focus();
    a.equal(unwrap(browser.document_active_element()), focusTarget);
  } finally {
    browser.element_remove_$x_(focusTarget);
  }
  a.equal(browser.window_local_storage(), localStorage);
  a.equal(browser.history_push_state_$x_(location.href), undefined);
  a.equal(browser.history_replace_state_$x_(location.href), undefined);

  const blob = browser.blob_create('你好');
  a.equal(blob.size, 6);
  const blobText = await browser.blob_text(blob);
  a.equal(isOk(blobText), true);
  a.equal(blobText.extra[0], '你好');
  const objectUrl = browser.object_url_create(blob);
  a.equal(typeof objectUrl, 'string');
  a.equal(browser.object_url_revoke_$x_(objectUrl), undefined);

  const image = browser.image_create();
  a.equal(browser.image_src_$x_(image, 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII='), undefined);
  const decoded = await browser.image_decode_$x_(image);
  a.equal(isOk(decoded), true);
  a.equal(browser.image_natural_width(image), 1);
  a.equal(browser.image_natural_height(image), 1);

  const pointerEvent = new PointerEvent('pointerdown', { clientX: 12, clientY: 34 });
  const pointerHost = browser.pointer_event_host(pointerEvent);
  a.equal(typeof pointerHost.layerX, 'number');
  a.equal(typeof pointerHost.layerY, 'number');
  const socket = browser.web_socket_create('ws://127.0.0.1:1/');
  a.equal(browser.web_socket_ready_state(socket), 0);
  browser.web_socket_on_open_$x_(socket, () => {});
  browser.web_socket_on_close_$x_(socket, () => {});
  browser.web_socket_on_error_$x_(socket, () => {});
  let socketMessage = null;
  browser.web_socket_on_message_$x_(socket, text => { socketMessage = text; });
  socket.onmessage({ data: 'hello' });
  a.equal(socketMessage, 'hello');
  a.equal(browser.web_socket_close_$x_(socket), undefined);
  a.equal(browser.web_socket_ready_state(socket) >= 2, true);
  if (typeof speechSynthesis !== 'undefined') {
    a.equal(browser.speech_synthesis_cancel_$x_(), undefined);
    a.equal(browser.speech_synthesis_speak_$x_('js-ffi smoke'), undefined);
    a.equal(browser.speech_synthesis_cancel_$x_(), undefined);
  }

  const boundaryElement = browser.create_element('div');
  a.equal(browser.element_data_set_$x_(boundaryElement, 'key', '值'), undefined);
  a.equal(unwrap(browser.element_data_get(boundaryElement, 'key')), '值');
  a.equal(browser.element_data_remove_$x_(boundaryElement, 'key'), undefined);
  a.equal(isNone(browser.element_data_get(boundaryElement, 'key')), true);
  a.equal(browser.element_set_style_$x_(boundaryElement, 'color', 'red'), undefined);
  a.equal(unwrap(browser.element_style_get(boundaryElement, 'color')), 'red');
  a.equal(isNone(browser.element_style_get(boundaryElement, 'unknown-prop')), true);
  const previousTitle = document.title;
  a.equal(browser.document_title_$x_('js-ffi title'), undefined);
  a.equal(browser.document_title(), 'js-ffi title');
  a.equal(browser.document_title_$x_(previousTitle), undefined);

  const mutable = browser.create_element('div');
  a.equal(browser.element_set_class_name_$x_(mutable, 'snippet'), undefined);
  a.equal(mutable.className, 'snippet');
  a.equal(browser.element_set_text_content_$x_(mutable, '值'), undefined);
  a.equal(mutable.textContent, '值');
  a.equal(browser.element_set_inner_html_$x_(mutable, '<b>hi</b>'), undefined);
  a.equal(mutable.innerHTML, '<b>hi</b>');
  a.equal(browser.element_set_hidden_$x_(mutable, true), undefined);
  a.equal(mutable.hidden, true);
  const inputLike = browser.create_element('input');
  a.equal(browser.element_set_value_$x_(inputLike, 'hello'), undefined);
  a.equal(inputLike.value, 'hello');
  a.equal(browser.element_set_placeholder_$x_(inputLike, 'hint'), undefined);
  a.equal(inputLike.placeholder, 'hint');
  a.equal(browser.element_set_css_text_$x_(inputLike, 'color: red;'), undefined);
  a.equal(inputLike.style.cssText.includes('color'), true);
  let mutableClicks = 0;
  const onMutableClick = () => { mutableClicks++; };
  a.equal(browser.element_add_event_listener_$x_(mutable, 'click', onMutableClick), undefined);
  mutable.click();
  a.equal(mutableClicks, 1);
  a.equal(browser.element_remove_event_listener_$x_(mutable, 'click', onMutableClick), undefined);
  mutable.click();
  a.equal(mutableClicks, 1);
  return { passed: true, assertions: a.count, runtime: navigator.userAgent, webgpu, webgpuRect };
}
