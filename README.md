# linden_evidence
WIP evidence system designed to work with ![ox_inventory](https://github.com/overextended/ox_inventory)

<h2 align='center'>On hold while I'm focusing on the development of the inventory!<br>There will be a complete rework.</h1>


Creates `Blood Splatter` when player receives damage.
* Collecting blood will give item `evidence_blood` with the player's name as the `metadata.description`


Creates both a `Bullet` and `Bullet Casing` when a firearm is used.
* Collecting them will give item `evidence_bullet` and `evidence_casing` with the serial number of the weapon used to create them set as the `metadata.description`

---

* Receive evidence table from the server when you connect.  
* Collect all evidence within range by pressing `e`, should properly remove the evidence from other clients and the server.  
* Does not create evidence when `WEAPON_STUNGUN` is fired (can easily be changed to create `prongs` and `cartridges`).  
* Support setting different names for `bullets` and `casings` for weapons - by default uses `pellets` and `shells` for shotguns.
