using UnityEngine;
using System.Collections;
using System.Linq;

public class Cube : MC_Base
{
    public GameObject[] cubes;
    public GameObject objs;
    public float loopTime;
    public float rotSpeed;

    public IEnumerator Rotate(Vector3 targetDir) {
        var t = loopTime;
        var q = Quaternion.FromToRotation(Vector3.forward, targetDir);
        while(t > 0 && objs.transform.rotation != q) {
            yield return new WaitForEndOfFrame();
            var step = rotSpeed * Time.deltaTime;
            objs.transform.rotation = Quaternion.RotateTowards(objs.transform.rotation, q, step);
            t -= Time.deltaTime;
        }
        StartCoroutine(Rotate(Random.onUnitSphere));
    }

    void Start() {
        StartCoroutine(Rotate(Random.onUnitSphere));
    }

    protected override void Update() {
        base.Update();

        drawer.mat.SetVectorArray("_Trans", cubes.Select(c =>
            new Vector4(
                c.transform.position.x,
                c.transform.position.y,
                c.transform.position.z,
                c.transform.localScale.x)
            ).ToArray()
        );
        drawer.mat.SetVectorArray("_Rots", cubes.Select(c => (Vector4)c.transform.rotation.eulerAngles * Mathf.Deg2Rad).ToArray());
    }
}
