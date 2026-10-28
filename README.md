# automation_keys

**One capability bit from GBT V8, packaged standalone.** No. 109 of 341,
`llm` domain (LLM).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 自动化配置密钥口（APP 设置调它）：六个槽位（codex/claude/deepseek/browser/free_pool/sec_llm）每槽只存**引用**（env:<环境变量名> / vault:<DPAPI profile> / local），**不存值**；输出只有掩码（前 4 字符 + ****）；set/unset 过 filesystem_write 门；test 做只读闭环自检（free_pool 只打本地 /v1，不花积分、不出公网）；where 给设置页看接线契约。真密钥一律走 model_key_pool 的 DPAPI 路径（六条红线在那边）。op=status/set/unset/test/where

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-automation-keys.git
cd gbt-automation-keys
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_automation_keys info                  # capability card
python -m gbt_automation_keys spec --json           # machine-readable contract
python -m gbt_automation_keys check --payload '{}'
python -m gbt_automation_keys run   --payload '{}'
```

Real `info` output from this machine:

```text
automation_keys  (llm)  v1.0.0
----------------------------------------
自动化配置密钥口（APP 设置调它）：六个槽位（codex/claude/deepseek/browser/free_pool/sec_llm）每槽只存**引用**（env:<环境变量名> / vault:<DPAPI profile> / local），**不存值**；输出只有掩码（前 4 字符 + ****）；set/unset 过 filesystem_write 门；test 做只读闭环自检（free_pool 只打本地 /v1，不花积分、不出公网）；where 给设置页看接线契约。真密钥一律走 model_key_pool 的 DPAPI 路径（六条红线在那边）。op=status/set/unset/test/where

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : codex, claude, deepseek, browser, free_pool, sec_llm
```

Wire a real implementation:

```python
from gbt_automation_keys import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（6 个）**：`codex`、`claude`、`deepseek`、`browser`、`free_pool`、`sec_llm`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.11s
```

## Provenance

| field | value |
|---|---|
| capability | `automation_keys` |
| domain | `llm` |
| handler | `automation_keys` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [llm/automation_keys](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/llm/automation_keys.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
