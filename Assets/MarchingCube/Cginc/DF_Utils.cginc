#ifndef utils_h 
#define utils_h 

#define PI 3.14159265358979

float3 mod(float3 a, float3 b) { return frac(abs(a / b)) * abs(b); }
float3 mod(float3 a, float1 b) { return frac(abs(a / b)) * abs(b); }
float2 mod(float2 a, float1 b) { return frac(abs(a / b)) * abs(b); }
float1 mod(float1 a, float1 b) { return frac(abs(a / b)) * abs(b); }

float3 reflect(float3 p, bool flip) { return float3(abs(p.x), p.yz); }
float3 repeat(float3 pos, float3 span) { return mod(pos, span) - span * 0.5; }

float smoothMax(float d1, float d2, float k) { return  log(exp( k * d1) + exp( k * d2)) / k; }
float smoothMin(float d1, float d2, float k) { return -log(exp(-k * d1) + exp(-k * d2)) / k; }
float smoothSub(float d1, float d2, float k) { return -log(exp(-k * d1) + exp( k * d2)) / k; }


float3 rotate(float3 p, float angle, float3 axis)
{
    float3 a = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float r = 1.0 - c;
    float3x3 m = float3x3(
        a.x * a.x * r + c,
        a.y * a.x * r + a.z * s,
        a.z * a.x * r - a.y * s,
        a.x * a.y * r - a.z * s,
        a.y * a.y * r + c,
        a.z * a.y * r + a.x * s,
        a.x * a.z * r + a.y * s,
        a.y * a.z * r - a.x * s,
        a.z * a.z * r + c
    );
    return mul(m, p);
}

float nrand(float2 co)
{
	return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
}

float3 nrand3(float2 co)
{
	float3 a = frac(cos(co.x*8.3e-3 + co.y)*float3(1.3e5, 4.7e5, 2.9e5));
	float3 b = frac(sin(co.x*0.3e-3 + co.y)*float3(8.1e5, 1.0e5, 0.1e5));
	float3 c = lerp(a, b, 0.5);
	return c;
}

#endif