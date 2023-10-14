Shader "Custom/BookStandard"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Normal ("Normal Map", 2D) = "bump" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard // fullforwardshadows

        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _Normal;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_Normal;
        };

        half _Glossiness;
        half _Metallic;

        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
			UNITY_DEFINE_INSTANCED_PROP(fixed4, _Color)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 instancedColor = UNITY_ACCESS_INSTANCED_PROP(Props, _Color);
            o.Albedo = lerp(instancedColor.rgb, c.rgb, c.a);
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
			o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal));
			o.Emission = o.Albedo / 5;
            o.Alpha = 1.0;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
