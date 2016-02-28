Name: clang-libcxx-edip
Version: %{_Version}	
Release: %{_Release}
Summary: EDiP compialtion of llvm,clang,libc++	

Distribution: CentOS 7
Vendor: EVERYDAYiPLAY
Packager: EVERYDAYiPLAY 

#Group:		
License: NCSA	
URL: http://www.llvm.org		
Source0: nothing

BuildRequires: gcc-c++ 
Requires: gcc gcc-c++ libxml2-devel

%description
LLVM, Clang, libc++

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/opt
cp -r %{SOURCE_DIRECTORY} %{buildroot}/opt/llvm
ls %{buildroot}/opt/llvm

%files
/opt/llvm

