import Lake
open Lake DSL

package catlib where
  leanOptions := #[
    ⟨`autoImplicit, false⟩
  ]

@[default_target]
lean_lib Catlib where
  srcDir := "."
