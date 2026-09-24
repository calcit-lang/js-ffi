import { test } from 'node:test';
import { assertions } from './shared.mjs';
import { testCalcitWebGpuCapabilities } from './webgpu-calcit-capabilities.mjs';

test('Calcit WebGPU capability contract on Node host doubles', async () => {
  const a = assertions();
  await testCalcitWebGpuCapabilities(a);
  console.log(`Calcit WebGPU capability: ${a.count} assertions`);
});
