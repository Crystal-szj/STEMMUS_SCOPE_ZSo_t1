function V = assignvarnames()
V                           = struct('Name','','Val', zeros(64,1));
V(1).Name                   = 'Cab';
V(2).Name                   = 'Cca';
V(3).Name                   = 'Cdm';
V(4).Name                   = 'Cw';
V(5).Name                   = 'Cs';
V(6).Name                   = 'N';
V(7).Name                   = 'rho_thermal';
V(8).Name                   = 'tau_thermal';
V(9).Name                   = 'Vcmo';
V(10).Name                   = 'm';  % see # 64, below for intercept: 'BallBerry0'
V(11).Name                  = 'Type';
V(12).Name                  = 'kV';
V(13).Name                  = 'Rdparam';
V(14).Name                  = 'Tparam';
V(15).Name                  = 'fqe';
V(16).Name                  = 'spectrum';
V(17).Name                  = 'rss';
V(18).Name                  = 'rs_thermal';
V(19).Name                  = 'cs';
V(20).Name                  = 'rhos';
V(21).Name                  = 'lambdas';
V(22).Name                  = 'LAI';
V(23).Name                  = 'hc';
V(24).Name                  = 'zo';
V(25).Name                  = 'd';
V(26).Name                  = 'LIDFa';
V(27).Name                  = 'LIDFb';
V(28).Name                  = 'leafwidth';
V(29).Name                  = 'z';
V(30).Name                  = 'Rin';
V(31).Name                  = 'Ta';
V(32).Name                  = 'Rli';
V(33).Name                  = 'p';
V(34).Name                  = 'ea';
V(35).Name                  = 'u';
V(36).Name                  = 'Ca';
V(37).Name                  = 'Oa';
V(38).Name                  = 'rb';
V(39).Name                  = 'Cd';
V(40).Name                  = 'CR';
V(41).Name                  = 'CD1';
V(42).Name                  = 'Psicor';
V(43).Name                  = 'CSSOIL';
V(44).Name                  = 'rbs';
V(45).Name                  = 'rwc';
V(46).Name                  = 'startDOY';
V(47).Name                  = 'endDOY';
V(48).Name                  = 'LAT';
V(49).Name                  = 'LON';
V(50).Name                  = 'timezn';
V(51).Name                  = 'tts';
V(52).Name                  = 'tto';
V(53).Name                  = 'psi';
V(54).Name                  = 'SMC';
V(55).Name                  = 'Tyear';
V(56).Name                  = 'beta';
V(57).Name                  = 'kNPQs';
V(58).Name                  = 'qLs';
V(59).Name                  = 'stressfactor';
V(60).Name                  = 'Cant';       %Added March 2017
V(61).Name                  = 'BSMBrightness';
V(62).Name                  = 'BSMlat';
V(63).Name                  = 'BSMlon';
V(64).Name                  = 'BallBerry0'; % acccidentally left out of v1.7
V(65).Name                  = 'RH';
end
