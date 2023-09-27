from pathlib import Path
import sys

out_dir = Path(sys.argv[1])

(out_dir / "foo.c").write_text("int foo(int x) {return x - 2;}")
(out_dir / "bar.c").write_text("int bar(int x) {return x - 3;}")
