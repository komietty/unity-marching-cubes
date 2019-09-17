#ifndef LIGHTING_UTIL_INCLUDED	
#define LIGHTING_UTIL_INCLUDED	

#include "AutoLight.cginc"	

UnityLight CreateLight(float3 wpos, float3 normal)
{
    UnityLight light;
#if defined(POINT) || defined(SPOT) || defined(POINT_COOKIE)	
		light.dir = normalize(_WorldSpaceLightPos0.xyz - wpos);	
#else	
    light.dir = _WorldSpaceLightPos0.xyz;
#endif	

    UNITY_LIGHT_ATTENUATION(attenuation, 0, wpos);
    light.color = _LightColor0.rgb * attenuation;
    light.ndotl = DotClamped(normal, light.dir);
    return light;
};	

UnityIndirect CreateIndirectLight_FWDBASE(float3 normal)
{
    UnityIndirect indirectLight;
    indirectLight.diffuse = 0;
    indirectLight.specular = 0;
    indirectLight.diffuse += max(0, ShadeSH9(float4(normal, 1)));
    return indirectLight;
};	

UnityIndirect CreateIndirectLight_VERTEXLIGHT(float3 vertexLightColor)
{
    UnityIndirect indirectLight;
    indirectLight.diffuse = 0;
    indirectLight.specular = 0;
    indirectLight.diffuse = vertexLightColor;
    return indirectLight;
};	

#endif 	
