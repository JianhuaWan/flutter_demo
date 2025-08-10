import 'dart:io';

void main() {
  // 1. 更新pubspec.yaml中的项目名称
  updatePubspecName();
  
  // 2. 重命名文件
  renameFiles();
  
  // 3. 更新所有文件中的导入语句
  updateImportStatements();
  
  print('命名优化完成！');
}

void updatePubspecName() {
  final pubspecFile = File('pubspec.yaml');
  final content = pubspecFile.readAsStringSync();
  final updatedContent = content.replaceFirst('name: flutter_app', 'name: real_estate_app');
  pubspecFile.writeAsStringSync(updatedContent);
  print('已更新 pubspec.yaml 中的项目名称为 real_estate_app');
}

void renameFiles() {
  // 重命名 city_selecto.dart 为 city_selector.dart
  final oldFile = File('lib/page/home/city_selecto.dart');
  final newFile = File('lib/page/home/city_selector.dart');
  
  if (oldFile.existsSync()) {
    oldFile.renameSync(newFile.path);
    print('已重命名 city_selecto.dart 为 city_selector.dart');
  }
}

void updateImportStatements() {
  // 需要更新的映射关系
  final importUpdates = {
    'package:flutter_app/page/home/city_selecto.dart': 'package:real_estate_app/page/home/city_selector.dart',
    'package:flutter_app/': 'package:real_estate_app/',
  };
  
  // 获取所有dart文件
  final dartFiles = <File>[];
  collectDartFiles(Directory('lib'), dartFiles);
  collectDartFiles(Directory('test'), dartFiles);
  
  int totalUpdates = 0;
  
  // 更新每个文件中的导入语句
  for (final file in dartFiles) {
    final content = file.readAsStringSync();
    String newContent = content;
    int fileUpdates = 0;
    
    for (final update in importUpdates.entries) {
      if (newContent.contains(update.key)) {
        newContent = newContent.replaceAll(update.key, update.value);
        fileUpdates++;
      }
    }
    
    // 如果文件内容有变化，则写回文件
    if (newContent != content) {
      file.writeAsStringSync(newContent);
      totalUpdates += fileUpdates;
      print('更新了文件 ${file.path} 中的导入语句');
    }
  }
  
  print('总共更新了 $totalUpdates 个导入语句');
}

void collectDartFiles(Directory dir, List<File> files) {
  if (!dir.existsSync()) return;
  
  dir.listSync().forEach((entity) {
    if (entity is File && entity.path.endsWith('.dart')) {
      files.add(entity);
    } else if (entity is Directory) {
      collectDartFiles(entity, files);
    }
  });
}