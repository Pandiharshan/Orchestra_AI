import os
import re

def fix_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    # Fix withOpacity
    content = re.sub(r'\.withOpacity\(([^)]+)\)', r'.withValues(alpha: \1)', content)
    
    # Fix translate deprecation in Matrix4 (e.g. ..translate(0.0, -2.0) -> ..translateByDouble(0.0, -2.0, 0.0), actually let's see)
    # The warning says: 'translate' is deprecated and shouldn't be used. Use translateByDouble or translateBy.
    content = re.sub(r'\.\.translate\(([^,]+),\s*([^)]+)\)', r'..translateByDouble(\1, \2, 0.0)', content)
    
    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Fixed {filepath}")

for root, dirs, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            fix_file(os.path.join(root, file))
