Shader "Hidden/PostProcess"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Tex01 ("Tex01", 2D) = "white" {}
    }
    SubShader
    {
        Cull Off ZWrite Off ZTest Always

		CGINCLUDE

		#include "UnityCG.cginc"
		sampler2D _MainTex;
		sampler2D _Tex01;
	    float4 _MainTex_TexelSize;
		float2 _Split;


		float2 split(float2 inUV) {
			return frac(inUV * _Split.xy);
		}

		fixed4 frag_base(v2f_img i) : SV_Target{
		    float2 uv = split(i.uv);
			fixed4 c = tex2D(_MainTex, uv);
			return c;
		}

		fixed4 mask_horizontal(v2f_img i) : SV_Target {
			fixed4 c = tex2D(_MainTex, i.uv);
		    uint uv = (uint)(i.uv.y * _MainTex_TexelSize.w);
		    bool flag = uv % 8 == 0;
			return flag ? c : 0;
		}

		fixed4 mask_diagonal(v2f_img i) : SV_Target {
			fixed4 c = tex2D(_MainTex, i.uv);
		    uint2 uv = (uint2)(i.uv.xy * _MainTex_TexelSize.zw);
		    bool flag = (uv.x + uv.y) % 8 == 0;
			return flag ? c : 0;
		}

	    ENDCG

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag_base 
            ENDCG
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment mask_horizontal
            ENDCG
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment mask_diagonal
            ENDCG
        }
    }
}
