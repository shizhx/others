1. put `run_performance_testing.sh` to root of `flare-floss` source
2. copy `flare-floss/strings.py` and modify like these:

```diff
--- floss/strings.py	2016-06-16 21:33:19.621958146 +0800
+++ floss/strings_buf_filled_with.py	2016-06-16 21:41:43.261593599 +0800
@@ -1,5 +1,6 @@
 import re
 from collections import namedtuple
+import mmap
 
 
 ASCII_BYTE = " !\"#\$%&\'\(\)\*\+,-\./0123456789:;<=>\?@ABCDEFGHIJKLMNOPQRSTUVWXYZ\[\]\^_`abcdefghijklmnopqrstuvwxyz\{\|\}\\\~\t"
@@ -90,7 +91,7 @@
     import sys
 
     with open(sys.argv[1], 'rb') as f:
-        b = f.read()
+        b = mmap.mmap(f.fileno(), 0, access=mmap.ACCESS_READ)
 
     for s in extract_ascii_strings(b):
         print('0x{:x}: {:s}'.format(s.offset, s.s))
```

```diff
--- floss/strings.py	2016-06-16 21:33:19.621958146 +0800
+++ floss/strings_count.py	2016-06-16 21:41:04.876652302 +0800
@@ -44,7 +44,7 @@
     if not buf:
         return
 
-    if (buf[0] in REPEATS) and buf_filled_with(buf, buf[0]):
+    if (buf[0] in REPEATS) and buf.count(buf[0]) == len(buf):
         return
 
     r = None
@@ -71,7 +71,7 @@
     if not buf:
         return
 
-    if (buf[0] in REPEATS) and buf_filled_with(buf, buf[0]):
+    if (buf[0] in REPEATS) and buf.count(buf[0]) == len(buf):
         return
 
     if n == 4:
```

3. run `run_performance_testing.sh`
