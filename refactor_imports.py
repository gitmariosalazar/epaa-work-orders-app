import os
import glob

def refactor_files(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)
                with open(filepath, 'r') as f:
                    content = f.read()

                # Basic package rename
                content = content.replace('package:app_properties/features/properties', 'package:clean_architecture/features/connections')
                content = content.replace('package:app_properties/', 'package:clean_architecture/')

                # Move entity imports to the core feature if they are duplicates
                content = content.replace('features/connections/search/domain/entities', 'features/connections/domain/entities')
                content = content.replace('features/connections/form/update/domain/entities', 'features/connections/domain/entities')

                # Replace old shared imports
                content = content.replace('components/common/custom_text_field.dart', 'shared_ui/components/common/custom_text_field.dart')
                content = content.replace('core/di/injection.dart', 'config/injector/injector.dart')
                content = content.replace('utils/responsive_utils.dart', 'core/utils/responsive/responsive_utils.dart')
                content = content.replace('utils/ui_helpers.dart', 'shared_ui/utils/ui_helpers.dart')

                with open(filepath, 'w') as f:
                    f.write(content)

if __name__ == '__main__':
    refactor_files('lib/features/connections')
