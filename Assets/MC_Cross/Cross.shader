Shader "Custom/Cross"
{
	Properties {
		_Noise("Noise", Vector) = (0, 0, 0, 0)
	}
	SubShader
	{
		CGINCLUDE
		#include "../MarchingCube/Cginc/MarchingCubeHeader.cginc"
		#include "../MarchingCube/Cginc/DF_Primitive.cginc"
		#include "../MarchingCube/Cginc/DF_Utils.cginc"
		#include "../Packages/unity-gist/Cginc/SimplexNoise.cginc"
		float4 _Noise;

        float DistanceFunction(float3 p, float3 q)
		{
			float result;
			float _c = -cross(q + snoise3D(float4(p + _Noise.xyz, 1)) * _Noise.w);
			result = _c;
			return result + 0.5;
        };
        
        #include "../MarchingCube/Cginc/MarchingCubeFooterWireframe.cginc"
		ENDCG

		Pass
		{
			Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma target 5.0
			#pragma vertex vert
			#pragma geometry geom_wire
			#pragma fragment frag_wire_alt

			float4 frag_wire_alt(g2f_wire i) : SV_Target
            {
				float4 col = float4(_DiffuseColor.rgb, 1);
            	float3 barys;
            	barys.xy = i.barycentricCoordinates;
            	barys.z = 1 - barys.x - barys.y;
            	float3 deltas = fwidth(barys);
            	float3 smoothing = deltas * _WireframeSmoothing;
            	float3 thickness = deltas * _WireframeThickness;
            	barys = smoothstep(thickness, thickness + smoothing, barys);
            	float minBary = min(barys.x, min(barys.y, barys.z));
				float3 wCol = (i.worldPos.z < 0)? _WireframeColor : float3(1, 0, 0);
            	return float4(lerp(wCol, col.rgb, minBary).xyz, 1.0);
            }

			ENDCG
		}
	}
}
