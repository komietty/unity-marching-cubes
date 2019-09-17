#ifndef distfunc_primitive_h
#define distfunc_primitive_h
// source : http://iquilezles.org/www/articles/distfunctions/distfunctions.htm
// p : position, r : radius, s: size, n : normal

inline float sphere(float3 p, float r) { return length(p) - r; }
inline float roundBox(float3 p, float3 s, float round) { return length(max(abs(p) - s * 0.5, 0)) - round; }
inline float box(float3 p, float3 s) { return roundBox(p, s, 0); }
inline float torus(float3 p, float2 r) { return length(float2(length(p.xy) - r.x, p.z)) - r.y; }
inline float plane(float3 p, float4 n) { return dot(p, n.xyz) + n.w; }
inline float ellipsoid(float3 p, float3 r) { return (length(p / r) - 1) * min(min(r.x, r.y), r.z); }
inline float hex(float2 p, float2 h) { float2 q = abs(p); return max(q.x - h.y, max(q.x + q.y*0.57735, q.y*1.1547) - h.x); }
inline float hexagonalPrismY(float3 p, float2 h) { float3 q = abs(p); return max(q.y - h.y, max(q.z * 0.866025 + q.x * 0.5, q.x) - h.x); }
inline float link(float3 p, float l, float r1, float r2) { float3 q = float3(p.x, max(abs(p.y) - l, 0), p.z); return length(float2(length(q.xy) - r1, q.z)) - r2; }

inline float cylinder(float3 p, float2 r) {
    float2 d = abs(float2(length(p.xy), p.z)) - r;
    return min(max(d.x, d.y), 0) + length(max(d, .0));
}

inline float capsule(float3 p, float3 start, float3 end, float radius) {
    float3 pa = p - start, ba = end - start;
	float h = clamp(dot(pa, ba) / dot(ba, ba), 0, 1);
    return length(pa - ba * h) - radius;
}


inline float cross(float3 p) {
    float b1 = box(p - float3(0, 0.23, 0), float3(0.6, 0.15, 0.15));
    float b2 = box(p, float3(0.15, 1, 0.15));
    return min(b1, b2);
}


// 3Dnization of 2D 

inline float sdVesica(float2 p, float r, float d)
{
    p = abs(p);
    float b = sqrt(r * r - d * d);
    return ((p.y - b) * d > p.x * b) ? length(p - float2(0, b)) : length(p - float2(-d, 0)) - r;
}

float sdCross(float2 p, float2 b, float r)
{
    p = abs(p);
    p = (p.y > p.x) ? p.yx : p.xy;
    float2 q = p - b;
    float k = max(q.y, q.x);
    float2 w = (k > 0.0) ? q : float2(b.y - p.x, -k);
    return sign(k) * length(max(w, 0.0)) + r;
}

float opExtrussion(float3 p, float sdf, float h)
{
    float2 w = float2(sdf, abs(p.z) - h);
    return min(max(w.x, w.y), 0.0) + length(max(w, 0.0));
}

#endif