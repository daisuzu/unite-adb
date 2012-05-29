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
let s:adb_keyevent = 'input keyevent '

let s:android_cmd = g:adb_cmd . g:adb_opt
let s:android_intent = g:adb_cmd . g:adb_opt . g:adb_sh

let s:android_operation = {}
let s:android_operation['Browser/Google'] = s:adb_am . 'android.intent.action.VIEW -d http://www.google.co.jp'
let s:android_operation['Key/Enter'] = s:adb_keyevent . '66'
let s:android_operation['Key/Up'] = s:adb_keyevent . '19'
let s:android_operation['Key/Down'] = s:adb_keyevent . '20'
let s:android_operation['Key/Left'] = s:adb_keyevent . '21'
let s:android_operation['Key/Right'] = s:adb_keyevent . '22'
let s:android_operation['Key/Home'] = s:adb_keyevent . '3'
let s:android_operation['Key/Menu'] = s:adb_keyevent . '82'
let s:android_operation['Key/Back'] = s:adb_keyevent . '4'
let s:android_operation['Key/Headsethook'] = s:adb_keyevent . '79'
let s:android_operation['Setting/Settings'] = s:adb_am . 'android.intent.action.MAIN -n com.android.settings/.Settings'
let s:android_operation['Setting/Airplane'] = s:adb_am . 'android.settings.AIRPLANE_MODE_SETTINGS'
let s:android_operation['Dial/117'] = s:adb_am . 'android.intent.action.DIAL -d tel:117'
let s:android_operation['Reboot'] = 'reboot'

let s:unite_source = {
      \ 'name' : 'adb',
      \ 'hooks' : {},
      \ }

let s:android_command = []
function! s:unite_source.hooks.on_init(args, context)
    let s:android_command = []

    for key in keys(s:android_operation)
        let cmd = len(split(key, '/')) == 2 ? s:android_intent : s:android_cmd
        call add(s:android_command, {
              \ 'word' : key,
              \ 'kind' : 'command',
              \ 'action__command' : 'call system("' . cmd . s:android_operation[key] .'")',
              \ })
    endfor

    if exists('g:android_operation')
        for key in keys(g:android_operation)
            let cmd = len(split(key, '/')) == 2 ? s:android_intent : s:android_cmd
            call add(s:android_command, {
                  \ 'word' : key,
                  \ 'kind' : 'command',
                  \ 'action__command' : 'call system("' . cmd . g:android_operation[key] .'")',
                  \ })
        endfor
    endif
endfunc

function! s:unite_source.gather_candidates(args, context)
    return s:android_command
endfunction

function! unite#sources#adb#define()
  return s:unite_source
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
