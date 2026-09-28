import { assertEquals } from "https://deno.land/std@0.224.0/assert/assert_equals.ts";
import { check } from "./pre-tool-use.ts";

Deno.test("markdown file triggers reminder", () => {
  const input = JSON.stringify({ file_path: "/foo/bar/README.md" });
  const result = check(input);
  assertEquals(result.length, 1);
});

Deno.test("non-markdown file triggers nothing", () => {
  const input = JSON.stringify({ file_path: "/foo/bar/index.ts" });
  assertEquals(check(input).length, 0);
});

Deno.test(".md in directory name but not extension triggers nothing", () => {
  const input = JSON.stringify({ file_path: "/foo/.mdx/config.json" });
  assertEquals(check(input).length, 0);
});

Deno.test(".mdx file does not trigger", () => {
  const input = JSON.stringify({ file_path: "/foo/bar/page.mdx" });
  assertEquals(check(input).length, 0);
});

Deno.test("empty input triggers nothing", () => {
  assertEquals(check("").length, 0);
});
