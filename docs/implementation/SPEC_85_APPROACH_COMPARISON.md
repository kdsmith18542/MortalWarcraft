# Spec 85: Chat Implementation Approach Comparison

## Hook-Based Approach (Current Implementation) ✅ **RECOMMENDED**

### How It Works
- Uses `PlayerScript::OnPlayerCanUseChat()` hook
- Intercepts messages at line 570 in `ChatHandler.cpp` (before channel processing)
- Checks channel name, validates, then allows/denies

### Performance
- **Optimal**: Hook is already in the critical path
- Called once per message, early in pipeline
- Minimal overhead (just string comparison + validation checks)
- No additional network overhead
- No separate module loading

### Pros
✅ **Zero external dependencies** - works with existing channel system  
✅ **Lightweight** - ~200 lines of code vs. full module  
✅ **Integrated** - all code in `mortal_overhaul` module  
✅ **Maintainable** - single location for all chat rules  
✅ **Flexible** - easy to modify rules without touching core channel code  
✅ **Performance** - hook is already called, no extra overhead  
✅ **Works immediately** - no module installation needed  

### Cons
⚠️ Doesn't provide `.chat` command (can be added separately if needed)  
⚠️ Relies on channel name matching ("World")  

---

## Module-Based Approach (mod-global-chat fork)

### How It Would Work
- Fork `mod-global-chat` as `mod-mortal-chat`
- Create dedicated module with channel management
- Add zone/progression checks to module

### Performance
- **Similar**: Still needs to validate messages
- Additional module loading overhead
- More complex codebase to maintain

### Pros
✅ More control over channel lifecycle  
✅ Can provide `.chat` command  
✅ More explicit channel management  
✅ Follows spec recommendation exactly  

### Cons
❌ **Requires external module** that doesn't exist in codebase  
❌ **More code to maintain** - full module vs. simple hook  
❌ **More complex setup** - separate module installation  
❌ **Dependency risk** - module may not be maintained  
❌ **Overkill** - full module for simple validation rules  

---

## Recommendation: **Hook-Based Approach**

### Why It's More Optimal:

1. **Performance**: 
   - Hook is already called in the critical path
   - No additional overhead vs. module approach
   - Early validation prevents unnecessary processing

2. **Simplicity**:
   - ~200 lines of code vs. full module
   - All logic in one place
   - Easy to understand and modify

3. **Maintainability**:
   - No external dependencies
   - Integrated with existing mortal_overhaul module
   - Follows existing codebase patterns

4. **Functionality**:
   - Achieves all spec requirements:
     - ✅ Zone restrictions (Red Zone radio silence)
     - ✅ Progression requirements (onboarded, skill points)
     - ✅ Rate limiting (15 second cooldown)
     - ✅ Optional gold cost
     - ✅ GM bypass

5. **Future-Proof**:
   - Easy to add `.chat` command later if needed
   - Can be refactored to module if requirements grow
   - No breaking changes to existing systems

---

## Missing Feature: `.chat` Command

The spec mentions `.chat` command for broadcasting. This can be added separately:

```cpp
// In MortalChatCommand.cpp
class MortalChatCommandScript : public CommandScript
{
    // .worldchat <message> - Send message to World channel
    static bool HandleWorldChatCommand(ChatHandler* handler, const char* args)
    {
        // Validate, then send to World channel
    }
};
```

This is a minor feature that doesn't require a full module.

---

## Conclusion

**The hook-based approach is more optimal** because:
- Same performance (hook is already in critical path)
- Simpler codebase (200 lines vs. full module)
- No external dependencies
- Achieves all spec requirements
- Easier to maintain and modify

The module approach would only be better if:
- You need complex channel lifecycle management
- You want to fork an existing maintained module
- You need features beyond simple validation

For Mortal's needs (zone restrictions, progression checks, rate limiting), **the hook-based approach is the optimal choice**.

