import 'package:flutter/material.dart';
import 'package:flutter_app_series_api/tv_show_grid.dart';
import 'package:flutter_app_series_api/tv_show_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TvShowSearchScreen extends StatefulWidget {
  const TvShowSearchScreen({super.key});

  @override
  State<TvShowSearchScreen> createState() => _TvShowSearchScreenState();
}

class _TvShowSearchScreenState extends State<TvShowSearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  late Future<List<TvShow>>? searchResults;

  bool onSubmit = false;

  void submit() {
    if (_formKey.currentState!.validate()) {
      final tvShowModel = context.read<TvShowModel>();
      setState(() {
        onSubmit = true;
        searchResults = tvShowModel.searchTvShows(_controller.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Search Series',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(height: 30),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: submit, icon: Icon(Icons.search)),
                    onSubmit
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                _controller.clear();
                                onSubmit = false;
                              });
                            },
                            icon: Icon(Icons.clear),
                          )
                        : Container(),
                  ],
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 16),
          onSubmit
              ? Expanded(
                  child: FutureBuilder<List<TvShow>>(
                    future: searchResults,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: SizedBox(
                            height: 96,
                            width: 96,
                            child: CircularProgressIndicator(strokeWidth: 12),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Container(
                            padding: EdgeInsets.all(32),
                            child: Column(
                              spacing: 32,
                              children: [
                                Text(
                                  'Error: ${snapshot.error}',
                                  style: TextStyle(fontSize: 24),
                                ),
                                ElevatedButton(
                                  onPressed: () => context.go('/'),
                                  child: Text('Back'),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (onSubmit &&
                          (!snapshot.hasData || snapshot.data!.isEmpty)) {
                        return Center(
                          child: Container(
                            padding: EdgeInsets.all(32),
                            child: Column(
                              spacing: 32,
                              children: [
                                Text(
                                  'No series found!',
                                  style: TextStyle(fontSize: 24),
                                ),
                                ElevatedButton(
                                  onPressed: () => context.go('/'),
                                  child: Text('Back'),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Column(children: [
                          Text('${snapshot.data!.length} series found!',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            child: TvShowGrid(
                              tvShows: snapshot.data!
                            ),
                          ),
                        ],
                      );
                      }
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
