## Bash Task 2

Company DEF decided to use testing tool for their employees. But current tool has no json output that can be using for later data processing.

1. Need to parce output.txt to convert into output.json:

## Example:

### this is output.txt:
```
[ Asserts Samples ], 1..2 tests
-----------------------------------------------------------------------------------
not ok  1  expecting command finishes successfully (bash way), 7ms
ok  2  expecting command prints some message (the same as above, bats way), 10ms
-----------------------------------------------------------------------------------
1 (of 2) tests passed, 1 tests failed, rated as 50%, spent 17ms
```

### should be output.json:
```json
{
 "testName": "Asserts Samples",
 "tests": [
   {
     "name": "expecting command finishes successfully (bash way)",
     "status": false,
     "duration": "7ms"
   },
   {
     "name": "expecting command prints some message (the same as above, bats way)",
     "status": true,
     "duration": "10ms"
   }
 ],
 "summary": {
   "success": 1,
   "failed": 1,
   "rating": 50,
   "duration": "17ms"
 }
}
```
