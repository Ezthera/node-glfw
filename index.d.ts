export interface Window {}

export function Init(): void;
export function Terminate(): void;
export function DefaultWindowHints(): void;
export function CreateGLFWWindow(width: number, height: number, title: string): Window;
export function MakeContextCurrent(window: Window): void;
export function SwapInterval(vsyncSwitch: number): void;
export function DestroyWindow(window: Window): void;
export function PopMatrix(): void;
export function SwapBuffers(window: Window): void;
export function PollEvents(): void;
export function PushMatrix(): void;
export function Ortho(left: number, right: number, bottom: number, top: number, nearVal: number, farVal: number): void;

export function draw2x2Streams(
  window: Window,
  channelCount: number,
  depthBuffer: Float32Array,
  depthFormat: string,
  depthWidth: number,
  depthHeight: number,
  colorBuffer: Float32Array,
  colorFormat: string,
  colorWidth: number,
  colorHeight: number
): void;
