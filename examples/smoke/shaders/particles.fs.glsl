#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler1, sampler2, sampler3, sampler4;
varying vec3 position;
varying vec4 color;
varying float idx;
varying vec2 vTexCoord;

#include "rng.glsl"

void main() {
  gl_FragColor = color;
  gl_FragColor.xyz *= (1. - gl_PointCoord.y) * 0.1 + 0.9;
  gl_FragColor.a *= 2. * max(0., 0.5 - length(gl_PointCoord - 0.5));
  gl_FragColor.a *= texture2D(sampler4, gl_PointCoord).r;
}