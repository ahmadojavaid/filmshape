import 'package:flutter/widgets.dart';
import 'package:new_flutter_mar/BLocs/AuthBLoc.dart';
import 'package:new_flutter_mar/Network/AuthServiceAPI.dart';

class AuthProvider extends InheritedWidget {
  final AuthBLoc authBLoc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  AuthProvider({
    Key key,
    AuthBLoc authBloc,
    Widget child,
  })  : authBLoc = authBloc ?? AuthBLoc(authAPI: new AuthServiceAPI()),
        super(key: key, child: child);

  static AuthBLoc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(AuthProvider) as AuthProvider)
          .authBLoc;
}
