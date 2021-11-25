import 'package:flutter/widgets.dart';
import 'package:new_flutter_mar/BLocs/DashboardBloc.dart';
import 'package:new_flutter_mar/Network/DashboardServiceApi.dart';

class DashboardProvider extends InheritedWidget {
  final DashboardBloc authBLoc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  DashboardProvider({
    Key key,
    DashboardBloc authBloc,
    Widget child,
  })  : authBLoc =
            authBloc ?? DashboardBloc(authAPI: new DashboardServiceAPi()),
        super(key: key, child: child);

  static DashboardBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(DashboardProvider)
              as DashboardProvider)
          .authBLoc;
}
