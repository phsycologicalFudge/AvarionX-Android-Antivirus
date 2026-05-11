package com.colourswift.cssecurity;

interface ISystemWatcherService {
  String ps();
  String proc(int pid);
  String procParsed(int pid);
  String externalSnapshot(String root, int maxFiles);
  String fdSnapshot();
  int shExit(String cmd);
  String shOut(String cmd);
  void destroy();
}