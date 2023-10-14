Shader "Custom/Scope"
{
    Properties
    {
        _Color ("Rim Color", Color) = (1,1,1,1)
		_MaskTex ("Mask", 2D) = "white" {}
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
		_RimEmission ("Rim Emission", Range(0, 1)) = 0.0
		_TextureEmission ("Texture Emission", Range(0, 1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _MaskTex;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_MaskTex;
        };

        half _Glossiness;
        half _Metallic;
		half _RimEmission;
		half _TextureEmission;
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			fixed mask = tex2D(_MaskTex, IN.uv_MaskTex).r;
			fixed4 textureColor = tex2D(_MainTex, IN.uv_MainTex);
			fixed3 finalColor = lerp(_Color.rgb, textureColor.rgb, mask);
			fixed emission = lerp(_RimEmission, _TextureEmission, mask);

			o.Albedo = (1 - emission) * finalColor;
			o.Emission = emission * finalColor;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
