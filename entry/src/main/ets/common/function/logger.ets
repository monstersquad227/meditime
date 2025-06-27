import { hilog } from '@kit.PerformanceAnalysisKit';

class Logger {
    /**
     * Indicates the log color.
     */
    private domain: number;
    /**
     *  Indicates the log prefix string.
     */
    private prefix: string;

    /**
     * Constructor.
     *
     * @param prefix Identifies the log tag.
     * @param domain Indicates the service domain, which is a hexadecimal integer ranging from 0x0 to 0xFFFFF
     */
    constructor(prefix: string, domain: number) {
        this.prefix = prefix;
        this.domain = domain;
    }

    /**
     * Outputs debug-level logs
     * @param format format Indicates the log format string
     * @param args args Indicates the log parameters
     */
    debug(format: string, ...args: Object[]): void {
        hilog.debug(this.domain, this.prefix, format, args);
    }

    /**
     * Outputs info-level logs
     * @param format format Indicates the log format string
     * @param args args Indicates the log parameters
     */
    info(format: string, ...args: Object[]): void {
        hilog.info(this.domain, this.prefix, format, args);
    }

    /**
     * Outputs warning-level logs
     * @param format format Indicates the log format string
     * @param args args Indicates the log parameters
     */
    warn(format: string, ...args: Object[]): void {
        hilog.warn(this.domain, this.prefix, format, args);
    }

    /**
     * Outputs error-level logs
     * @param format format Indicates the log format string
     * @param args args Indicates the log parameters
     */
    error(format: string, ...args: Object[]): void {
        hilog.error(this.domain, this.prefix, format, args);
    }
}

export default new Logger('PushKitDemo', 0xFF00);