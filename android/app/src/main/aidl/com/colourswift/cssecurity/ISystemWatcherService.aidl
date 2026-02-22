package com.colourswift.cssecurity;

interface ISystemWatcherService {
  String ps();
  String proc(int pid);
  int shExit(String cmd);
  String shOut(String cmd);
  void destroy();
}