import 'package:flutter/widgets.dart';
import 'package:social_network_flutter/common/framework/ui/toast/custom_toast.dart';

class CustomToastParentWidget extends StatefulWidget {
  final Widget child;

  const CustomToastParentWidget({super.key, required this.child});

  @override
  State<CustomToastParentWidget> createState() => AGToastParentWidgetState();
}

class AGToastParentWidgetState extends State<CustomToastParentWidget> {
  @override
  void initState() {
    super.initState();
    CustomToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
