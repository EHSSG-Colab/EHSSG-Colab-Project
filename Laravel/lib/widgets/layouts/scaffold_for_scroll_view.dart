import 'package:flutter/material.dart';

class ScaffoldForScrollView extends StatelessWidget {
  const ScaffoldForScrollView({
    super.key,
    this.appBar,
    required this.children,
    required this.canPop,
    this.bottomNavigationBar,
  });
  final bool canPop;
  final List<Widget> children;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

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
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        32,
                        0,
                        32,
                        0,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: children,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
