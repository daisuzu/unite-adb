let s:save_cpo = &cpo
set cpo&vim


if !exists('g:adb_cmd')
    let g:adb_cmd = 'adb '
endif

if !exists('g:adb_opt')
    let g:adb_opt = ' '
endif

if !exists('g:adb_sh')
    let g:adb_sh = 'shell '
endif

let s:adb_am = 'am start -a '
let s:adb_input = 'input keyevent '

let s:android_intent = {}
let s:android_intent['Browser/Google'] = s:adb_am . 'android.intent.action.VIEW -d http://www.google.co.jp'
let s:android_intent['Key/Enter'] = s:adb_input . '66'
let s:android_intent['Key/Up'] = s:adb_input . '19'
let s:android_intent['Key/Down'] = s:adb_input . '20'
let s:android_intent['Key/Left'] = s:adb_input . '21'
let s:android_intent['Key/Right'] = s:adb_input . '22'

let s:unite_source = {
      \ 'name' : 'adb',
      \ 'hooks' : {},
      \ }

let s:android_command = []
function! s:unite_source.hooks.on_init(args, context)
    let s:android_command = []
    let cmd = g:adb_cmd . g:adb_opt . g:adb_sh

    for key in keys(s:android_intent)
        call add(s:android_command, {
              \ 'word' : key,
              \ 'kind' : 'command',
              \ 'action__command' : 'call system("' . cmd . s:android_intent[key] .'")',
              \ })
    endfor
endfunc

function! s:unite_source.gather_candidates(args, context)
    return s:android_command
endfunction

" function! s:unite_source.gather_candidates(args, context)
"     let intents = deepcopy(s:android_intent)
"     let cmd = g:adb_cmd . g:adb_opt . g:adb_sh . s:adb_am
"     
"     return map(intents, '{
"                 \ "word": v:key,
"                 \ "source": 'adb/intent',
"                 \ "kind": ["command"],
"                 \ "action__command": cmd . v:val
"                 \ }')
" endfunction

function! unite#sources#adb#define()
  return s:unite_source
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
