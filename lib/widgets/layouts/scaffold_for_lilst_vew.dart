import 'package:flutter/material.dart';

class ScaffoldForListView extends StatelessWidget {
  const ScaffoldForListView({
    super.key,
    this.appBar,
    required this.child,
    required this.canPop,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });
  final bool canPop;
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: canPop,
        child: SafeArea(
          top: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 8,
                child: Container(
                  width: 100,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  alignment: const AlignmentDirectional(0, -1),
                  child: Container(
                    width: double.infinity,
                    alignment: const AlignmentDirectional(-1, 0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        32,
                        0,
                        32,
                        0,
                      ),
                      child: child,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
