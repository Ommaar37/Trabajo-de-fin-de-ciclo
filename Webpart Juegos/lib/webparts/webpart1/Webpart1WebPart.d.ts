import { Version } from '@microsoft/sp-core-library';
import { IPropertyPaneConfiguration } from '@microsoft/sp-property-pane';
import { BaseClientSideWebPart } from '@microsoft/sp-webpart-base';
import { IReadonlyTheme } from '@microsoft/sp-component-base';
export interface IWebpart1WebPartProps {
    description: string;
}
export default class Webpart1WebPart extends BaseClientSideWebPart<IWebpart1WebPartProps> {
    private _isDarkTheme;
    private _environmentMessage;
    private SP;
    render(): void;
    protected onInit(): Promise<void>;
    private _getEnvironmentMessage;
    protected onThemeChanged(currentTheme: IReadonlyTheme | undefined): void;
    protected onDispose(): void;
    protected get dataVersion(): Version;
    protected getPropertyPaneConfiguration(): IPropertyPaneConfiguration;
}
//# sourceMappingURL=Webpart1WebPart.d.ts.map