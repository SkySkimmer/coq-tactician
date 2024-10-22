open Map_all_the_things
open Monad_util

open Mapping_helpers
module NormalizeDef = struct
  include MapDefTemplate (IdentityMonad)
end
module NormalizeMapper = MakeMapper(NormalizeDef)
open NormalizeDef
open Helpers(NormalizeDef)

let placeholder () = match Rocqlib.lib_ref "tactician.private_constant_placeholder" with
  | Names.GlobRef.ConstRef const -> const
  | _ -> assert false

let mapper = { NormalizeDef.default_mapper with
               glob_constr_and_expr = (fun (expr, _) g -> g (expr, None))
             ; variable = (fun _ -> Names.Id.of_string "X")
             ; constant = (fun c -> placeholder ())
             ; constr_pattern = (fun _ _ -> Pattern.PMeta None)
             ; constr_expr = (fun _ _ -> CHole None)
             ; glob_constr = (fun _ _ -> Glob_term.GHole (Evar_kinds.GQuestionMark Evar_kinds.default_question_mark))
             }

let tactic_normalize = NormalizeMapper.glob_tactic_expr_map mapper
