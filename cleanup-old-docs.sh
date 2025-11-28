#!/bin/bash
# Move old documentation to archive (don't delete, just organize)

ARCHIVE_DIR="docs/archive/old-reports"
mkdir -p "$ARCHIVE_DIR"

# Move old status/report files
for file in \
    ABSOLUTE_FINAL_VERIFICATION.md \
    ALL_IMPLEMENTATIONS_COMPLETE.md \
    BUILD_TEST_COMPLETE_REPORT.md \
    COMPLETE_TODO_RESOLUTION_REPORT.md \
    FINAL_100_PERCENT_STATUS.md \
    FINAL_AUDIT_REPORT.md \
    FINAL_COMPILATION_STATUS.md \
    FINAL_COMPLETION_STATUS.md \
    FINAL_POLISH_STATUS.md \
    FINAL_SESSION_REPORT.md \
    FINAL_SUMMARY.md \
    FINAL_VERIFICATION_REPORT.md \
    STUB_AUDIT_COMPLETE.txt \
    STUB_VERIFICATION_REPORT.md \
    TODO_FIX_COMPLETE_REPORT.md \
    VICTORY_REPORT.md; do
    if [ -f "$file" ]; then
        mv "$file" "$ARCHIVE_DIR/"
        echo "Moved: $file"
    fi
done

echo "✅ Old documentation archived to $ARCHIVE_DIR"
