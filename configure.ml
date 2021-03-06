let config_mk = "config.mk"

(* Configure script *)
open Cmdliner

let dir name default docv doc =
  let doc = Printf.sprintf "Set the directory for installing %s" doc in
  Arg.(value & opt string default & info [name] ~docv ~doc)

let path name default docv doc =
  let doc = Printf.sprintf "Set the path for %s" doc in
  Arg.(value & opt string default & info [name] ~docv ~doc)

let disable_warn_error =
  let doc = "Disable -warn-error (default is enabled for development)" in
  Arg.(value & flag & info [ "disable-warn-error" ] ~doc)

let varpatchdir = dir "varpatchdir" "/var/patch" "VARPATCHDIR" "hotfixes"
let etcdir = dir "etcdir" "/etc/xensource" "ETCDIR" "configuration files"
let optdir = dir "optdir" "/opt/xensource" "OPTDIR" "system files"
let plugindir = dir "plugindir" "/etc/xapi.d/plugins" "PLUGINDIR" "xapi plugins"
let extensiondir = dir "extensiondir" "/etc/xapi.d/extensions" "PLUGINDIR" "XenAPI extensions"
let hooksdir = dir "hooksdir" "/etc/xapi.d" "HOOKSDIR" "hook scripts"
let inventory = path "inventory" "/etc/xensource-inventory" "INVENTORY" "the inventory file"
let xapiconf = dir "xapiconf" "/etc/xapi.conf" "XAPICONF" "xapi master config file"
let libexecdir = dir "libexecdir" "/opt/xensource/libexec" "LIBEXECDIR" "utility binaries"
let scriptsdir = dir "scriptsdir" "/etc/xensource/scripts" "SCRIPTSDIR" "utility scripts"
let sharedir = dir "sharedir" "/opt/xensource" "SHAREDIR" "shared binary files"
let webdir = dir "webdir" "/opt/xensource/www" "WEBDIR" "html files"
let cluster_stack_root = dir "cluster-stack-root" "/usr/libexec/xapi/cluster-stack" "CLUSTER_STACK_ROOT" "cluster stacks"
let bindir = dir "bindir" "/opt/xensource/bin" "BINDIR" "binaries"
let sbindir = dir "sbindir" "/opt/xensource/bin" "BINDIR" "system binaries"
let udevdir = dir "udevdir" "/etc/udev" "UDEVDIR" "udev scripts"

let info =
  let doc = "Configures a package" in
  Term.info "configure" ~version:"0.1" ~doc

let output_file filename lines =
  let oc = open_out filename in
  let lines = List.map (fun line -> line ^ "\n") lines in
  List.iter (output_string oc) lines;
  close_out oc

let configure disable_warn_error varpatchdir etcdir optdir plugindir extensiondir hooksdir inventory xapiconf libexecdir scriptsdir sharedir webdir cluster_stack_root bindir sbindir udevdir =
  Printf.printf "Configuring with the following params:\n\tdisable_warn_error=%b\n\tvarpatchdir=%s\n\tetcdir=%s\n\toptdir=%s\n\tplugindir=%s\n\textensiondir=%s\n\thooksdir=%s\n\tinventory=%s\n\txapiconf=%s\n\tlibexecdir=%s\n\tscriptsdir=%s\n\tsharedir=%s\n\twebdir=%s\n\tcluster_stack_root=%s\n\tbindir=%s\n\tsbindir=%s\n\tudevdir=%s\n\n" disable_warn_error varpatchdir etcdir optdir plugindir extensiondir hooksdir inventory xapiconf libexecdir scriptsdir sharedir webdir cluster_stack_root bindir sbindir udevdir;

  (* Write config.mk *)
  let lines =
    [ "# Warning - this file is autogenerated by the configure script";
      "# Do not edit";
      Printf.sprintf "DISABLE_WARN_ERROR=%b" disable_warn_error;
      Printf.sprintf "VARPATCHDIR=%s" varpatchdir;
      Printf.sprintf "ETCDIR=%s" etcdir;
      Printf.sprintf "OPTDIR=%s" optdir;
      Printf.sprintf "PLUGINDIR=%s" plugindir;
      Printf.sprintf "EXTENSIONDIR=%s" extensiondir;
      Printf.sprintf "HOOKSDIR=%s" hooksdir;
      Printf.sprintf "INVENTORY=%s" inventory;
      Printf.sprintf "XAPICONF=%s" xapiconf;
      Printf.sprintf "LIBEXECDIR=%s" libexecdir;
      Printf.sprintf "SCRIPTSDIR=%s" scriptsdir;
      Printf.sprintf "SHAREDIR=%s" sharedir;
      Printf.sprintf "WEBDIR=%s" webdir;
      Printf.sprintf "CLUSTER_STACK_ROOT=%s" cluster_stack_root;
      Printf.sprintf "BINDIR=%s" bindir;
      Printf.sprintf "SBINDIR=%s" sbindir;
      Printf.sprintf "UDEVDIR=%s" udevdir
    ] in
  output_file config_mk lines

let configure_t = Term.(pure configure $ disable_warn_error $ varpatchdir $ etcdir $ optdir $ plugindir $ extensiondir $ hooksdir $ inventory $ xapiconf $ libexecdir $ scriptsdir $ sharedir $ webdir $ cluster_stack_root $ bindir $ sbindir $ udevdir )

let () =
  match
    Term.eval (configure_t, info)
  with
  | `Error _ -> exit 1
  | _ -> exit 0
