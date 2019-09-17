using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PostProcess : MonoBehaviour {

    public Material mat;
    public int pass;
    public Vector2Int split;

    void OnRenderImage(RenderTexture src, RenderTexture dst) {
        mat.SetVector("_Split", new Vector4(split.x, split.y, 0, 0));
        Graphics.Blit(src, dst, mat, pass);
    }

    void UpdateSplit(int x, int y) { split = new Vector2Int(x, y); }
}
