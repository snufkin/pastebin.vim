" ViM Pastebin extension
"
" Original version by Dennis, at
" http://djcraven5.blogspot.com/2006/10/vimpastebin-post-to-pastebin-from.html
"
" Updated in 2008 Olivier Lê Thanh Duong <olethanh@gmail.com>
" to use an XML-RPC interface compatible with http://paste.debian.net/rpc-interface.html
"
" Updated in 2009 for python compatibility by Balazs Dianiska
" <balazs@longlake.co.uk>
"
" Updated in 2010 for pastebin.com compatibility, removed gajim and xmlrpc
" support.
"
" Make sure the Vim was compiled with +python before loading the script...
if !has("python")
        finish
endif

" Map a keystroke for Visual Mode only (default:F2)
:vmap <f2> :PasteCode<cr>

" Send to pastebin 
:command -range             PasteCode :py PasteMe(<line1>,<line2>)
" Pastebin the complete file
:command                    PasteFile :py PasteMe()

python << EOF
import vim
import urllib 
from re import compile
import xmlrpclib

################### BEGIN USER CONFIG ###################
# Set this to your preferred pastebin
pastebin = 'http://pastebin.com/api_public.php'
# Set this to your preferred username
user = 'anonmyous'
subdomain = 'mydomain'
#################### END USER CONFIG ####################

def PasteMe(start=-1, end=-1):
    url = PBSendPOST(start, end)
    # Print the result url
    print url

def PBSendPOST(line1, line2, format='text'):
 # TODO decide format from the file type
    supported_formats = {
        'text' : 'text', 'bash' : 'bash', 'python' : 'python', 'c' : 'c',
        'cpp' : 'cpp', 'html' : 'html4strict', 'java' : 'java',
        'javascript' : 'javascript', 'perl' : 'perl', 'php' : 'php',
        'sql' : 'sql', 'ada' : 'ada', 'apache' : 'apache', 'asm' : 'asm',
        'aspvbs' : 'asp', 'dcl' : 'caddcl', 'lisp' : 'lisp', 'cs' : 'csharp',
        'css' : 'css', 'lua' : 'lua', 'masm' : 'mpasm', 'nsis' : 'nsis',
        'objc' : 'objc', 'ora' : 'oracle8', 'pascal' : 'pascal',
        'basic' : 'qbasic', 'smarty' : 'smarty', 'vb' : 'vb', 'xml' : 'xml'
    }

    code = '\n'.join(vim.current.buffer[int(line1)-1:int(line2)])

    data = {
    'paste_format': 'text', # TODO
    'paste_code': code,
    'paste_subdomain': subdomain,
    'paste_name': user
    }

    params = urllib.urlencode(data)
    u = urllib.urlopen(pastebin, params)
    return u.read()
EOF

