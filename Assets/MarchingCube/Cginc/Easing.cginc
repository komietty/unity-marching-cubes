#ifndef EASING_INCLUDED
#define EASING_INCLUDED

float EaseInQuad(float t) { return t * t; }

float EaseOutQuad(float t) { return t * (2 - t); }

float EaseInOutQuad(float t) { return t < .5 ? 2 * t * t : -1 + (4 - 2 * t) * t; }

float EaseInOutCubic(float t) { return t < .5 ? 4 * t * t * t : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1; }

float EaseInOutQuart(float t) { return t < .5 ? 8 * t * t * t * t : 1 - 8 * (--t) * t * t * t; }

float EaseInOutQuint(float t) { return t < .5 ? 16 * t * t * t * t * t : 1 + 16 * (--t) * t * t * t * t; }

#endif