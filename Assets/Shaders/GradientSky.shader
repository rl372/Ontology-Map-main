Shader "Skybox/Gradient Sky"
{
	Properties
	{
		_SkyColor("Sky Color", Color) = (0.4, 0.4, 0.8, 1)
		_HorizonColor("Horizon Color", Color) = (0.95, 0.95, 1, 1)
		_BottomColor("Bottom Color", Color) = (0.8, 0.8, 0.8, 1)
		_UpperSharpness("Upper Sharpness", Range(0.5, 10)) = 1
		_UpperDistance("Upper Distance", Range(0, 50)) = 1
		_LowerSharpness("Lower Sharpness", Range(0.5, 10)) = 1
		_LowerDistance("Lower Distance", Range(0, 50)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Background" "Queue"="Background" "PreviewType"="Skybox"}
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
            };

            struct v2f {
				float4 localPosition : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                UNITY_TRANSFER_FOG(o,o.vertex);
				o.localPosition = float4(v.vertex.xyz, 1);
                return o;
            }

			fixed4 _SkyColor;
			fixed4 _HorizonColor;
			fixed4 _BottomColor;
			fixed _UpperSharpness;
			fixed _UpperDistance;
			fixed _LowerSharpness;
			fixed _LowerDistance;

			float remap(float value, float oldMin, float oldMax, float newMin, float newMax) {
				return (value - oldMin) / (oldMax - oldMin) * (newMax - newMin) + newMin;
			}

			fixed4 frag(v2f i) : SV_Target{
				float height = i.localPosition.y;
				
				float topFactor = step(0, height) * pow(saturate(remap(height, 0, 1, 0, _UpperDistance)), 1/_UpperSharpness);
				topFactor = saturate(topFactor);
				float bottomFactor = step(height, 0) * pow(saturate(remap(abs(height), 0, 1, 0, _LowerDistance)), 1/_LowerSharpness);
				bottomFactor = saturate(bottomFactor);

				fixed4 col = (topFactor ? 1 : 0) * lerp(_HorizonColor, _SkyColor, topFactor);
				col += (bottomFactor ? 1 : 0) * lerp(_HorizonColor, _BottomColor, bottomFactor);

				UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
