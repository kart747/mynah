import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/providers.dart';
import '../../data/db/app_database.dart';
import 'import_service.dart';

const sampleBookAssets = [
  'assets/samples/alice-in-wonderland.epub',
  'assets/samples/adventures-of-sherlock-holmes.epub',
];

final importServiceProvider = Provider<ImportService>(
  (ref) => ImportService(
    ref.watch(bookRepositoryProvider),
    getApplicationDocumentsDirectory,
  ),
);

/// Number of files currently being imported; drives the progress bar.
class ImportController extends Notifier<int> {
  @override
  int build() => 0;

  ImportService get _service => ref.read(importServiceProvider);

  /// Opens the system picker. Returns one result per picked file.
  Future<List<ImportResult>> pickAndImport() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['epub'],
    );
    final results = <ImportResult>[];
    for (final file in files) {
      // The picker filter is only a hint on some file providers.
      if (file.extension?.toLowerCase() != 'epub') {
        results.add(ImportFailure(file.name, 'only EPUB is supported so far'));
        continue;
      }
      results.add(await _run(file.name, file.readAsBytes));
    }
    return results;
  }

  Future<List<ImportResult>> addSampleBooks() async {
    final results = <ImportResult>[];
    for (final asset in sampleBookAssets) {
      results.add(await _run(asset.split('/').last, () async {
        final data = await rootBundle.load(asset);
        return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      }));
    }
    return results;
  }

  Future<void> deleteBook(Book book) => _service.deleteBook(book);

  Future<ImportResult> _run(
    String name,
    Future<Uint8List> Function() readBytes,
  ) async {
    state++;
    try {
      return await _service.importEpub(name, await readBytes());
    } catch (e) {
      return ImportFailure(name, e.toString());
    } finally {
      state--;
    }
  }
}

final importControllerProvider =
    NotifierProvider<ImportController, int>(ImportController.new);
