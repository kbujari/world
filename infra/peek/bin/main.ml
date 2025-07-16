let parse_meminfo line =
  let parts = String.split_on_char ':' line in
  match parts with
  | [ key; value ] -> (
      let vparts = String.trim value |> String.split_on_char ' ' in
      match vparts with
      | [ num; "kB" ] -> Some (String.trim key, int_of_string num)
      | [ num ] -> Some (String.trim key, int_of_string num)
      | _ -> None)
  | _ -> None

let mem_stats =
  In_channel.open_bin "/proc/meminfo"
  |> In_channel.input_lines
  |> List.filter_map parse_meminfo
  |> List.fold_left
       (fun tbl (k, v) -> Hashtbl.replace tbl k v; tbl)
       (Hashtbl.create 16)

let mem_used =
  let total = Hashtbl.find mem_stats "MemTotal" |> float_of_int in
  let used = Hashtbl.find mem_stats "MemAvailable" |> float_of_int in
  used /. total
