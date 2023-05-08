import logging

DEBUG = "debug"
INFO = "info"
WARNING = "warning"
ERROR = "error"

def Singleton(cls):
    instances = {}

    def _singleton(*args, **kwargs):
        if cls not in instances:
            instances[cls] = cls(*args, **kwargs)
        return instances[cls]

    return _singleton


@Singleton
class Logger:
    def __init__(self, log_level):
        
        self.__log_level = self.__get_log_level(log_level)
        self.logger = logging.getLogger("SingletonLogger")
        self.logger.setLevel(self.__log_level)
        
        self.stream_handler = logging.StreamHandler()
        self.stream_handler.setLevel(self.__log_level)
        
        self.log_fmt = logging.Formatter("[%(asctime)s][%(levelname)s]:%(message)s")
        self.stream_handler.setFormatter(self.log_fmt)
        self.logger.addHandler(self.stream_handler)
        
        self.grey = '\x1b[38;21m'
        self.blue = '\x1b[38;5;39m'
        self.yellow = '\x1b[38;5;226m'
        self.red = '\x1b[38;5;196m'
        self.bold_red = '\x1b[31;1m'
        self.reset = '\x1b[0m'

    def info(self, message):
        self.logger.info(message)

    def debug(self, message):
        self.logger.debug(self.grey+message+self.reset)

    def warning(self, message):
        self.logger.warning(self.yellow+message+self.reset)

    def error(self, message):
        self.logger.error(self.red+message+self.reset)
        
    
    def __get_log_level(self, level_str):
        LOG_LEVEL_DICT = {
            DEBUG:logging.DEBUG,
            INFO:logging.INFO,
            WARNING:logging.WARNING,
            ERROR:logging.ERROR
        }
        if level_str not in LOG_LEVEL_DICT.keys():
            raise ValueError("Invalid log level {}, should be one of follows:\n{}".format(
                level_str, LOG_LEVEL_DICT.keys()))
        return LOG_LEVEL_DICT[level_str]
        
        
        




