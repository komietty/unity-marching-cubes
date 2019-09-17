using UnityEngine;
using System.Linq;
using DG.Tweening;

public class Drop : MC_Base {

    [Header("Drop")]
    [Range(0, 1)] public float lerpVal;
    public Vector4 letterLerp;
    public GameObject[] balls;
    public int pattern;

    protected override void Update() {
        base.Update();

        drawer.mat.SetFloat("_LerpVal", lerpVal);
        drawer.mat.SetInt("_Pattern", pattern);
        drawer.mat.SetVector("_LetterLerp", letterLerp);
        drawer.mat.SetVectorArray("_Params", balls.Select(b =>
            new Vector4(
                b.transform.position.x,
                b.transform.position.y,
                b.transform.position.z,
                b.transform.localScale.x / 2)
            ).ToArray()
        );
    }

    public void Lerp() {
        var i = Mathf.FloorToInt(Random.value * 4);
        var to = letterLerp[i] > 0.5f ? 0 : 1;
        if (i == 2) pattern = Random.value > 0.5 ? 1 : 0;
        DOTween.To(() => letterLerp[i], v => letterLerp[i] = v, to, 1f);
    }
}
