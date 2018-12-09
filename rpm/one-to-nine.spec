Name: one-to-nine
Summary: Sudoku game

Version: 0.1.0
Release: 1
Group: Amusements/Games
License: GPLv2.1
URL: https://github.com/Kaffeine/one-to-nine
Source0: https://github.com/Kaffeine/one-to-nine/releases/download/one-to-nine-%{version}/one-to-nine-%{version}.tar.bz2
BuildRequires: qt%{_qt5_version}-qtcore-devel
BuildRequires: qt%{_qt5_version}-qtgui-devel
BuildRequires: qt%{_qt5_version}-qtdeclarative-devel
BuildRequires: qt%{_qt5_version}-qtdeclarative-qtquick-devel
BuildRequires: qt%{_qt5_version}-qtquickcontrols2-devel
BuildRequires: qt%{_qt5_version}-qmake

%description
%{summary}.

%prep
%setup -q -n %{name}-%{version}

%build
%{qmake_qt5} \
  "INSTALL_PREFIX=%{_qt5_prefix}" \
  "INSTALL_BIN_DIR=%{_qt5_bindir}"

make %{?_smp_mflags}

%install
rm -rf %{buildroot}
make install INSTALL_ROOT=%{buildroot}

%files
%defattr(-,root,root,-)
%{_qt5_bindir}/one-to-nine
