import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_kosmos/skeleton_kosmos.dart';

@RoutePage()
class HostLevelPage extends StatefulHookConsumerWidget {
  const HostLevelPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HostLevelPageState();
}

class _HostLevelPageState extends ConsumerState<HostLevelPage> {
  @override
  Widget build(BuildContext context) {
    return const ScrollingPage(
      child: Column(),
    );
  }
}
