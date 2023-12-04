import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LusidSdkAngular16Component } from './lusid-sdk-angular16.component';

describe('LusidSdkAngular16Component', () => {
  let component: LusidSdkAngular16Component;
  let fixture: ComponentFixture<LusidSdkAngular16Component>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [LusidSdkAngular16Component]
    });
    fixture = TestBed.createComponent(LusidSdkAngular16Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
