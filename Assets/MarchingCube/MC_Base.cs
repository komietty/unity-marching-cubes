using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MC_Base : MonoBehaviour
{
    public MarchingCubeDrawMesh drawer;
    public Vector3Int segments;
    public Material mat;
    public Color diffuseColor = Color.green;
    public Color emissionColor = Color.black;
    public float emissionIntensity = 0;
    public Color wireframeColor = Color.white;
    [Range(-1, 1)] public float threashold = 0.5f;
    [Range(0, 10)] public float wireframeSmoothness = 0.5f;
    [Range(0, 10)] public float wireframeThickness = 0.5f;
    [Range(0, 1)] public float metallic = 0;
    [Range(0, 1)] public float glossiness = 0.5f;

    protected virtual void OnEnable() {
        drawer.mat = mat;
        drawer.segments = segments;
    }

    protected virtual void Update() {
        drawer.mat.SetFloat("_Threashold", threashold);
        drawer.mat.SetFloat("_Metallic", metallic);
        drawer.mat.SetFloat("_Glossiness", glossiness);
        drawer.mat.SetFloat("_EmissionIntensity", emissionIntensity);
        drawer.mat.SetColor("_DiffuseColor", diffuseColor);
        drawer.mat.SetColor("_EmissionColor", emissionColor);
        drawer.mat.SetColor("_WireframeColor", wireframeColor);
        drawer.mat.SetFloat("_WireframeSmoothing", wireframeSmoothness);
        drawer.mat.SetFloat("_WireframeThickness", wireframeThickness);
    }
}
