## Locals

In addition to standard module layout,
locals follow a standard layout based on level sets.

* The entry point is `l0_map`, where any name mapping for keys is done.
* Most attributes are created in `l1_map`, where standard names are merged and default values are injected.
* Attributes are synthesized in `l2_map`...`ln_map`
* Attributes are merged in `lx_map` and this is used to create resources.

See [the locals template](module_template/locals.tf).
